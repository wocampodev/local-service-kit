# Contributing

Thanks for improving Local Service Kit.

Before opening a pull request:

```sh
make format
make check
```

When adding a service:

1. Add its variables to `.local.env.example`.
2. Add `src/<service>.sh`.
3. Add the service name to `SERVICES` in `Makefile`.
4. Document ports, credentials, init behavior, and GUI hints in `README.md`.

Keep scripts small, boring, and easy to debug.
