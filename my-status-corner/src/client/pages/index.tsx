import React from 'react';
import UploadForm from '../components/UploadForm';
import StatusList from '../components/StatusList';

const HomePage: React.FC = () => {
    return (
        <div>
            <h1>My Status Corner</h1>
            <UploadForm />
            <StatusList />
        </div>
    );
};

export default HomePage;