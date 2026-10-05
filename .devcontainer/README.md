# Multi-repository workspace

This Dev Container combines separately managed host repositories into one VS Code workspace:

- The development-environment repository is mounted at `/workspace`.
- The API and UI repositories are mounted below `/workspace`.
- Host Git checkouts remain available to host Git clients and are not cloned or updated by the container.

## Set up the workspace

1. Create the Compose environment file:

	```bash
	cp .devcontainer/.env.example .devcontainer/.env
	```

2. Set each variable in `.devcontainer/.env` to the absolute host path of the corresponding repository or file.

	On Windows, use Windows-style paths, for example `C:/path/to/api-repo`.

3. Create the API runtime environment file:

	```bash
	cp .devcontainer/docker-compose.env.example .devcontainer/docker-compose.env
	```

4. Review the runtime settings and replace any placeholder values.

5. Open the repository in VS Code and rebuild the Dev Container.

Rebuild the container after changing repository paths, runtime environment variables, tool versions, or API dependencies.

## Git authentication and commit signing

VS Code Dev Containers copies the host Git configuration and forwards its Git
credential helper and SSH agent. This supports HTTPS pushes and SSH pushes
without copying private credentials into the container.

After rebuilding, verify the setup inside the container:

```bash
ssh-add -l
git config --show-origin --get user.signingkey
git config --get gpg.format  # should be "ssh"
$(git config --get core.sshCommand) -T git@github.com  # should name the account with access
git commit --allow-empty -m "Verify devcontainer signing"
git log -1 --show-signature
git push --dry-run origin HEAD
```

## Database

The workspace starts a local PostgreSQL service and reuses the existing development data volume.

- Stop any other PostgreSQL container using the same volume before starting this Dev Container.
- Do not remove the volume if you want to preserve existing development data.
- See `.devcontainer/docker-compose.env.example` for the API connection settings.
