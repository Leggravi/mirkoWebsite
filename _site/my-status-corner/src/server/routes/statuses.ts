import { Router } from 'express';
import { uploadStatus, getStatuses } from '../controllers/statusesController';

const router = Router();

router.post('/statuses', uploadStatus);
router.get('/statuses', getStatuses);

export default router;