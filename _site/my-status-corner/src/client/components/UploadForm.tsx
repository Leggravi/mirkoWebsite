import React, { useState } from 'react';

const UploadForm = () => {
    const [file, setFile] = useState(null);
    const [description, setDescription] = useState('');

    const handleFileChange = (event) => {
        setFile(event.target.files[0]);
    };

    const handleDescriptionChange = (event) => {
        setDescription(event.target.value);
    };

    const handleSubmit = async (event) => {
        event.preventDefault();
        if (!file || !description) {
            alert('Please provide both a file and a description.');
            return;
        }

        const formData = new FormData();
        formData.append('file', file);
        formData.append('description', description);

        try {
            const response = await fetch('/api/statuses', {
                method: 'POST',
                body: formData,
            });

            if (response.ok) {
                alert('Upload successful!');
                setFile(null);
                setDescription('');
            } else {
                alert('Upload failed. Please try again.');
            }
        } catch (error) {
            console.error('Error uploading file:', error);
            alert('An error occurred. Please try again.');
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <input type="file" onChange={handleFileChange} required />
            <textarea
                value={description}
                onChange={handleDescriptionChange}
                placeholder="Add a description"
                required
            />
            <button type="submit">Upload</button>
        </form>
    );
};

export default UploadForm;