# My Status Corner

My Status Corner is a web application that allows users to upload photos and share short descriptions, creating a personal status feed. The application is designed to be user-friendly, enabling quick uploads directly from mobile devices.

## Features

- **Photo Uploads**: Easily upload photos from your device.
- **Status Descriptions**: Add a brief description to each photo.
- **Date Sorting**: Uploaded statuses are displayed in chronological order.
- **Responsive Design**: Optimized for both desktop and mobile devices.

## Project Structure

```
my-status-corner
├── src
│   ├── client
│   │   ├── pages
│   │   │   └── index.tsx
│   │   ├── components
│   │   │   ├── UploadForm.tsx
│   │   │   └── StatusList.tsx
│   │   └── styles
│   │       └── global.css
│   ├── server
│   │   ├── app.ts
│   │   ├── routes
│   │   │   └── statuses.ts
│   │   ├── controllers
│   │   │   └── statusesController.ts
│   │   ├── models
│   │   │   └── status.ts
│   │   └── utils
│   │       └── storage.ts
│   └── types
│       └── index.ts
├── public
│   └── uploads
├── package.json
├── tsconfig.json
├── .gitignore
└── README.md
```

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/my-status-corner.git
   ```
2. Navigate to the project directory:
   ```
   cd my-status-corner
   ```
3. Install the dependencies:
   ```
   npm install
   ```

## Usage

1. Start the server:
   ```
   npm run start
   ```
2. Open your browser and navigate to `http://localhost:3000` to access the application.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for details.