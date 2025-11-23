export interface Status {
    id: string;
    imageUrl: string;
    description: string;
    createdAt: Date;
}

export interface UploadStatusResponse {
    success: boolean;
    message: string;
    status?: Status;
}

export interface FetchStatusesResponse {
    success: boolean;
    statuses: Status[];
}