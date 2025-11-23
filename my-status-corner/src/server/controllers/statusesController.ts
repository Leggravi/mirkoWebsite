import { Request, Response } from 'express';
import { Status } from '../models/status';
import { saveFile } from '../utils/storage';

// Function to handle uploading a new status
export const uploadStatus = async (req: Request, res: Response) => {
    try {
        const { description } = req.body;
        const file = req.file;

        if (!file || !description) {
            return res.status(400).json({ message: 'File and description are required.' });
        }

        const imageUrl = await saveFile(file);
        const newStatus = new Status({ imageUrl, description });

        // Save the new status to the database (implementation depends on your database setup)
        await newStatus.save();

        return res.status(201).json(newStatus);
    } catch (error) {
        return res.status(500).json({ message: 'Error uploading status', error });
    }
};

// Function to handle retrieving all statuses
export const getStatuses = async (req: Request, res: Response) => {
    try {
        // Fetch all statuses from the database (implementation depends on your database setup)
        const statuses = await Status.find().sort({ createdAt: -1 });
        return res.status(200).json(statuses);
    } catch (error) {
        return res.status(500).json({ message: 'Error retrieving statuses', error });
    }
};