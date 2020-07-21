# Installation
To set up dependencies, make sure you have Python 3.7.3, and run 
`pipenv install` in the `backend/` directory. Then, run 
`pipenv shell` to activate the `virtualenv`

# Environment
Add a `.env` file in `backend/` following the example of 
`.env.sample`, and replace the MONGO_URI. 

# Starting the Backend
To start the backend, run `uvicorn app.main:app --reload` in `backend/`. Docs can be 
viewed at `localhost:8000/docs`!
