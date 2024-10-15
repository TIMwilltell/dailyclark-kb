A personal knowledgebase static site.

Create a `.env` at the root directory.
Add the following:

```bash
DOCS_PATH=/local/path/to/main/content/docs/
WORK_PATH=/local/path/to/other/content/
RECIPES_PATH=/local/path/to/recipes/content/
```

Run `docker compose up --build -d` to run in development mode with hot reloading.
