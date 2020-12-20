# mmap to wiredtiger migration

Starting with the major release 4.X.Y of Rocket.Chat, MongoDB has to be setup with a *WiredTiger* storage engine rather than the deprecated *mmap* one. This is mandandory, if you plan to upgrade to one of the future Rocket.Chat versions and has to be prepared before initiating the application upgrade.

This project aims to help out people migrating their existing dockerized, *mmap* based MongoDB installation into a *WiredTiger* one.

## Usage

For usage instructions, please check our docs: https://docs.rocket.chat/installation/docker-containers/mongodb-mmap-to-wiredtiger-migration

## Contributing

1. Fork it
2. Create your feature branch:

    ```shell
    git checkout -b feature/my-new-feature
    ```

3. Commit your changes:

    ```shell
    git commit -am 'Add some feature'
    ```

4. Push to the branch:

    ```shell
    git push origin feature/my-new-feature
    ```

5. Submit a pull request

## License

[MIT](LICENSE)
