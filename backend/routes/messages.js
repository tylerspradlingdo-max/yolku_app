const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const rateLimit = require('express-rate-limit');
const { User, Facility, Conversation, Message } = require('../models');

const messagesRateLimit = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 60,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many requests, please try again later.' }
});

router.use(messagesRateLimit);

/**
 * Middleware that accepts either a healthcare worker token or a facility token.
 * Sets req.actorType ('user' | 'facility') and req.actorId on success.
 */
const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, error: 'No token provided' });
    }

    const token = authHeader.substring(7);
    const secret = process.env.JWT_SECRET || 'your_jwt_secret_key';
    const decoded = jwt.verify(token, secret);

    if (decoded.type === 'facility' && decoded.facilityId) {
      req.actorType = 'facility';
      req.actorId = decoded.facilityId;
    } else if (decoded.userId) {
      req.actorType = 'user';
      req.actorId = decoded.userId;
    } else {
      return res.status(401).json({ success: false, error: 'Invalid token payload' });
    }

    next();
  } catch (error) {
    return res.status(401).json({ success: false, error: 'Invalid or expired token' });
  }
};

/**
 * GET /api/messages/conversations
 * List all conversations for the authenticated actor.
 */
router.get('/conversations', authMiddleware, async (req, res) => {
  try {
    const where = req.actorType === 'user'
      ? { userId: req.actorId }
      : { facilityId: req.actorId };

    const conversations = await Conversation.findAll({
      where,
      include: [
        { model: User, as: 'user', attributes: ['id', 'firstName', 'lastName', 'profession'] },
        { model: Facility, as: 'facility', attributes: ['id', 'name', 'city', 'state', 'facilityType'] },
        {
          model: Message,
          as: 'messages',
          limit: 1,
          order: [['createdAt', 'DESC']],
          attributes: ['content', 'senderType', 'createdAt', 'isRead'],
          separate: true
        }
      ],
      order: [['updatedAt', 'DESC']]
    });

    res.json({ success: true, data: conversations });
  } catch (error) {
    console.error('List conversations error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch conversations' });
  }
});

/**
 * GET /api/messages/conversations/:id
 * Get all messages in a conversation.
 */
router.get('/conversations/:id', authMiddleware, async (req, res) => {
  try {
    const where = { id: req.params.id };
    if (req.actorType === 'user') where.userId = req.actorId;
    else where.facilityId = req.actorId;

    const conversation = await Conversation.findOne({
      where,
      include: [
        { model: User, as: 'user', attributes: ['id', 'firstName', 'lastName', 'profession'] },
        { model: Facility, as: 'facility', attributes: ['id', 'name', 'city', 'state', 'facilityType'] },
        { model: Message, as: 'messages', order: [['createdAt', 'ASC']] }
      ]
    });

    if (!conversation) {
      return res.status(404).json({ success: false, error: 'Conversation not found' });
    }

    // Mark messages as read for the current actor
    await Message.update(
      { isRead: true },
      {
        where: {
          conversationId: conversation.id,
          senderType: req.actorType === 'user' ? 'facility' : 'user',
          isRead: false
        }
      }
    );

    res.json({ success: true, data: conversation });
  } catch (error) {
    console.error('Get conversation error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch conversation' });
  }
});

/**
 * POST /api/messages/conversations
 * Start a new conversation and send the first message.
 * Body: { facilityId (required for users), userId (required for facilities), content }
 */
router.post('/conversations',
  authMiddleware,
  [body('content').trim().notEmpty().withMessage('Message content is required')],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ success: false, errors: errors.array() });
      }

      const { content } = req.body;
      let userId, facilityId;

      if (req.actorType === 'user') {
        if (!req.body.facilityId) {
          return res.status(400).json({ success: false, error: 'facilityId is required' });
        }
        userId = req.actorId;
        facilityId = req.body.facilityId;

        // Verify facility exists
        const facility = await Facility.findByPk(facilityId);
        if (!facility) {
          return res.status(404).json({ success: false, error: 'Facility not found' });
        }
      } else {
        if (!req.body.userId) {
          return res.status(400).json({ success: false, error: 'userId is required' });
        }
        userId = req.body.userId;
        facilityId = req.actorId;

        // Verify user exists
        const user = await User.findByPk(userId);
        if (!user) {
          return res.status(404).json({ success: false, error: 'User not found' });
        }
      }

      // Find or create conversation
      const [conversation] = await Conversation.findOrCreate({
        where: { userId, facilityId },
        defaults: { userId, facilityId }
      });

      const message = await Message.create({
        conversationId: conversation.id,
        senderType: req.actorType,
        senderId: req.actorId,
        content
      });

      // Touch conversation updatedAt
      await conversation.update({ updatedAt: new Date() });

      res.status(201).json({ success: true, data: { conversation, message } });
    } catch (error) {
      console.error('Start conversation error:', error);
      res.status(500).json({ success: false, error: 'Failed to start conversation' });
    }
  }
);

/**
 * POST /api/messages/conversations/:id
 * Send a message in an existing conversation.
 * Body: { content }
 */
router.post('/conversations/:id',
  authMiddleware,
  [body('content').trim().notEmpty().withMessage('Message content is required')],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ success: false, errors: errors.array() });
      }

      const where = { id: req.params.id };
      if (req.actorType === 'user') where.userId = req.actorId;
      else where.facilityId = req.actorId;

      const conversation = await Conversation.findOne({ where });
      if (!conversation) {
        return res.status(404).json({ success: false, error: 'Conversation not found' });
      }

      const message = await Message.create({
        conversationId: conversation.id,
        senderType: req.actorType,
        senderId: req.actorId,
        content: req.body.content
      });

      // Touch conversation updatedAt
      await conversation.update({ updatedAt: new Date() });

      res.status(201).json({ success: true, data: message });
    } catch (error) {
      console.error('Send message error:', error);
      res.status(500).json({ success: false, error: 'Failed to send message' });
    }
  }
);

module.exports = router;
