import fs from 'fs';
import path from 'path';
import { v4 as uuidv4 } from 'uuid';

const uploadsDir = path.join(__dirname, '../../public/uploads');

if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}

export const saveFile = (file: Express.Multer.File): string => {
    const uniqueFilename = `${uuidv4()}-${file.originalname}`;
    const filePath = path.join(uploadsDir, uniqueFilename);
    fs.writeFileSync(filePath, file.buffer);
    return `/uploads/${uniqueFilename}`;
};

export const getFilePath = (filename: string): string => {
    return path.join(uploadsDir, filename);
};