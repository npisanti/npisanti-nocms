for video conversion:   
```console
ffmpeg -i input.mp4 -c:v libx264 output.mp4
```    
or
```console
ffmpeg -i input.mkv -codec copy output.mp4
```    
or
```
ffmpeg -i input.mp4 -pix_fmt yuv420p -c:v libx264 -movflags +faststart output.mp4
```

lately i encode to HD 
```
ffmpeg -i input.mp4 -b 1200k -vf scale=1280:720 output.mp4

```

for getting the thumbnails:   
```console
ffmpeg -i input.mp4 thumb%04d.jpg -hide_banner
```
