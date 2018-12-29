for video conversion:   
```console
ffmpeg -i input.mp4 -c:v libx264 output.mp4
```    

for getting the thumbnails:   
```console
ffmpeg -i input.mp4 thumb%04d.jpg -hide_banner
```
