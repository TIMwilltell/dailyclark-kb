A personal knowledgebase static site.

1. Clone this repo and `cd` into the project.
2. Create a `.env` at the root directory.
3. Add the following variables to that file:

```bash
DOCS_PATH=/local/path/to/main/content/docs/
WORK_PATH=/local/path/to/other/content/
RECIPES_PATH=/local/path/to/recipes/content/
```

4. Run `docker compose up --build -d` to run in development mode with hot reloading.
5. Navigate to `localhost:1313` in your browser to view your site.

For additional options, refer to the official Hugo and Hextra Theme documentation.

## Extras 

```markdown
[link]({{< ref Page Title >}})
```
