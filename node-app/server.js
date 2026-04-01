const http = require('http');
const fs = require('fs');

const server = http.createServer((req, res) => {
    fs.readFile('/var/www/node-app/index.html', (err, data) => {
        if (err) {
            console.log(err);
            res.writeHead(500);
            return res.end('Error loading HTML file');
        }

        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(data);
    });
});

server.listen(3000, () => {
    console.log('Server running on port 3000');
});
