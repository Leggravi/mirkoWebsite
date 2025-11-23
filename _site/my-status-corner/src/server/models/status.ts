import { Schema, model } from 'mongoose';

const statusSchema = new Schema({
    imageUrl: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

const Status = model('Status', statusSchema);

export default Status;