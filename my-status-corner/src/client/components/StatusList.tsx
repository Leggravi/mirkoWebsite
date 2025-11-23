import React, { useEffect, useState } from 'react';
import axios from 'axios';

const StatusList = () => {
    const [statuses, setStatuses] = useState([]);

    useEffect(() => {
        const fetchStatuses = async () => {
            try {
                const response = await axios.get('/api/statuses');
                setStatuses(response.data);
            } catch (error) {
                console.error('Error fetching statuses:', error);
            }
        };

        fetchStatuses();
    }, []);

    return (
        <div className="status-list">
            <h2>Uploaded Statuses</h2>
            {statuses.length > 0 ? (
                <ul>
                    {statuses.map((status) => (
                        <li key={status.id}>
                            <img src={status.imageUrl} alt={status.description} />
                            <p>{status.description}</p>
                            <p>{new Date(status.createdAt).toLocaleString()}</p>
                        </li>
                    ))}
                </ul>
            ) : (
                <p>No statuses available.</p>
            )}
        </div>
    );
};

export default StatusList;