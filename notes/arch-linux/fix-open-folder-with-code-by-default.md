## Arch linux + GNOME open folders with Visual Code instead of Nautilus

This just an error with `mimeinfo.cache` file, just fix with a command: 

```bash
sed -i 's,inode/directory=code.desktop;org.gnome.Nautilus.desktop;,inode/directory=org.gnome.Nautilus.desktop;code.desktop;,g' /usr/share/applications/mimeinfo.cache
```
