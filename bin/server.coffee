express     = require "express"
path        = require "path"
logger      = require "morgan"
bodyParser  = require "body-parser"
debug       = require("debug")("linkedInServices")
http        = require 'http'

app = express() 
app.set('root', process.cwd())

#get the port situated based on environment
if process.env['ENVIRONMENT'] == "production"
    _port = 8080;
else # Development env
    _port = 9000;

# sample setting environment variables
app.locals.appEnvVar = process.env['APP_ENV_VAR']

app.use '/static', express.static(path.join(app.get('root'), 'static'))
app.use(express.static(app.get("root") + '/public'))

app.engine('html', require('ejs').renderFile)

#app.options '*', (req,res) -> res.send(200)

app.get '/', (req, res) -> res.render 'app.html'
app.get '/index', (req, res) -> res.render 'app.html'
app.get '*', (req, res) -> res.redirect '/#/404'

server = http.createServer(app)

server.listen _port, ->
    console.log "running on port #{_port}"
    debug "App settings:", app.locals.settings


module.exports = app