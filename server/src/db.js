const mongoose = require('mongoose');
const url = `mongodb://my-app-mongo/test?authSource=admin`;

mongoose.connect(url, {
    useNewUrlParser: true,
    user: 'homestead',
    pass: 'secret'
}).then(() => {
    console.log('successfully connected to the database');
}).catch(err => {
    console.log('error connecting to the database', err);
    process.exit();
});

module.exports = mongoose;
