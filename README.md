# How to Setup and Run the server
1. Install Docker on your computer
2. Clone repository onto your computer
3. Optionally, configure the backend's secret key in the ```docker-compose.yml``` file
   * Default secret key is ```secretsecretsecret```
4. Backend will be running on http://0.0.0.0:8080 by default, so direct all http requests to that address
   * Customize which *port* to run it on by setting your system's ```SERVER_PORT``` environment variable to the desired port number before running
   * If you are fine with that URL, then you don't have to do anything, just make sure that a different process isn't already bound to that URL on your system
5. Run ```docker compose up```
6. If you want to see the documentation and play around with the API, go to http://127.0.0.1:8080/docs
7. If you want to test the API manually, I would recommend using the ```/docs``` endpoint as listed above, the Postman app, or if you have VSCode installed on your machine, you could use the Thunder Client extension or use the REST Client extension to run requests outlined in ```.http``` files. JetBrains IDEs also can support .http test files.
   * I have provided an ```example.http`` file in this directory if you do end up using the REST Client extension or a JetBrains IDE.

# What are JSON Web Tokens?
 - JSON Web Tokens (a.k.a JWTs) were introduced in RFC 7519 and serve to establish client privileges over a server's resources on the server's terms.
 - **Think of JWTs as a VIP Pass. Clients who send requests with a valid JWT will be granted access to server resources that are not publicly available.**
 - When a client wants to access a restricted server resource, they will need to request the server for a JWT.
 - If a server grants them a JWT, the client will be able to access the requested resource only if they store the JWT in their request's headers.
   - Specifically the token should be stored in the request's *Authorization* header and should follow the word *Bearer* (separated by space).
   - E.g. ```Authorization: Bearer <token>```
 - JWTs also have an expiration date, so clients will have to request the server for another JWT when their JWT expires.
 - You can learn more at [jwt.io](https://jwt.io/)

## Pros of JSON Web Tokens
 - Completely stateless, meaning the server doesn't have maintain any knowledge of who the client is.
   - All the server does is issue tokens, validates them, and grants/rejects access to its resources accordingly.
 - Very scalable, since this system demands very few additional computational resources on the server side for its implementation.

## Cons of JSON Web Tokens
 - Very vulnerable to Man-In-The-Middle attacks.
   - Attackers can steal or tag along with valid client requests if they intercept JWTs as they are sent to and from the client and server

# Our Interpretation of the JWT system
 - We decided to enhance the security of the traditional username and password system with JWTs.
 - This would require clients to register an account to receive a JWT, which they would use to access a restricted resource on the server.
 - Clients can also log out to delete their JWT from the server's database, and log back in to get a new JWT.
 - Our system provides a way for clients to have more control over their access to the server so their information isn't abused.
 - The system also allows the server to trace JWTs to user accounts and have JWT validity directly dependent on valid user credentials by signing tokens with a user's username in addition to the server's secret key.

# Our Implementation
 - The server is implemented using the FastAPI framework, which utilizes Python scripts to create a high-performance backend API.
 - The server will store client credentials and JWTs in a PostgreSQL database. 
   - Passwords will be hashed using the bcrypt algorithim before being stored in the database.
   - JWTs will be signed by the server and encrypted with the standard HMAC + SHA-256 (a.k.a HS256) algorithim before being stored and sent back to the user.
   - *All JWTs issued by the server have a 10-minute lifetime.*
 - All protected resources will be stored in the ```/backend/assets``` folder. Add files you want to protect to it before you setup and run the server.