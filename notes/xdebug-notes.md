# Xdebug notes

---

- `99-xdebug.ini`:

```ini
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_autostart=1
xdebug.start_with_request = yes
xdebug.mode=debug
```

- Add those line to `php.ini` also then restart the Apache2 service
