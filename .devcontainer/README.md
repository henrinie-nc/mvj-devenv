# Multi-repository workspace

This setup keeps Git repositories on the host and selectively mounts them into the container. The Dev Container configuration is mounted directly at `/workspace/.devcontainer`, and the configured repositories appear at `/workspace/api`, `/workspace/ui`, and `/workspace/ui-public`. VS Code opens `/workspace` as the workspace root so all of them are visible in the file tree.

## Select repositories

Create the Compose environment file from the template:

```bash
cp .devcontainer/.env.example .devcontainer/.env
```

Edit `.devcontainer/.env` with the host paths for the repositories you want to mount. Compose automatically loads this `.env` file and mounts them at stable container paths: `/workspace/api`, `/workspace/ui`, and `/workspace/ui-public`. Each developer can use different host paths while sharing the same container configuration. Rebuild the container after changing the paths.

On Windows, use Windows-style absolute paths in `.env`, for example `DEV_REPO_API=C:/Code/Helsinki/api`.

The Node.js and Python versions are installed by Dev Container Features and can be selected through `NODE_VERSION` and `PYTHON_VERSION`. Rebuild the container after changing either version. The base image is Debian Trixie; change the `FROM` image in `Dockerfile` if another distribution is required.

When the container is created, `.devcontainer/install-python-dependencies.sh` installs the API's locked runtime and development dependencies from `/workspace/api/requirements.txt` and `/workspace/api/requirements-dev.txt`. Rebuild the container (or run the script manually) after changing those files.

## Database

The Dev Container starts a new PostgreSQL container named `mvj-dev-db` while reusing the existing data volume `mvjdevcontainer_mvj-postgres-14-data-volume`. The database is reachable by the `dev` container as `localhost:5433`, with database `mvj-db`, user `mvj`, and password `mvj`. These credentials are for local development only.

Set `DB_NETWORK_NAME` if the existing database project uses a different network name:

```bash
export DB_NETWORK_NAME=mvjdevcontainer_default
```

Stop the old `mvj-db` container before starting this one, but do not remove its data volume. Only one PostgreSQL server may use the data directory at a time. The external volume declaration prevents Compose from silently creating a new empty database volume.

Compose is useful here because the database does not need to be installed in the development image and the development container does not need access to the host Docker or Podman socket.

Mounted repositories are normal host Git checkouts, so commits, branches, and Git clients on the host remain usable. The container does not clone or update them automatically.