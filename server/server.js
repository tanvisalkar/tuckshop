const jsonServer = require('json-server')
const server = jsonServer.create()
const router = jsonServer.router('db.json')
const middlewares = jsonServer.defaults()

// Set default middlewares (logger, static, cors and no-cache)
server.use(middlewares)

// Add custom routes before JSON Server router
server.get('/users', (req, res, next) => {
    console.log(Object.keys(req.query).length)
    console.log("get==")
    if(Object.keys(req.query).length >0){
        const token = "token"+Date.now()
        req.query.data={"token":token}
        res.json(req.query)
        // req.body.token = "token"+Date.now()
    }
    else{
        next()
    }
    
    //res.jsonp(req.query[0])
})

// To handle POST, PUT and PATCH you need to use a body-parser
// You can use the one used by JSON Server
server.use(jsonServer.bodyParser)
server.use((req, res, next) => {
	console.log(req.body)
    if (req.method === 'POST') {
    	console.log(req.url)
    	if(req.url === "/users"){
            const token = "token"+Date.now()
            req.body.data={"token":token}
        	// req.body.token = "token"+Date.now()
        }

    }
    // Continue to JSON Server router
    next()
})

// Use default router
server.use(router)
server.listen(5019, () => {
    console.log('JSON Server is running')
})