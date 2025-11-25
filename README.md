# truenas-home-server
All setup config for my TrueNAS SCALE Home Server

### OS:
* TrueNAS SCALE

### Apps:
* TrueNAS Apps:
    * JellyFin
        * Docs: https://jellyfin.org/docs/
    * Minecraft Java
    * Minecraft Bedrock
    * Portainer (custom containers)
        * Gluetun (VPN Client)
            * Docs: https://github.com/qdm12/gluetun
        * qBittorent
            * Docs: https://www.qbittorrent.org/
        * ClamAV
            * Docs: https://docs.clamav.net/manual/Installing/Docker.html
            * Guide:
                * First build the required image from the Dockerfile.
        * FileBot
            * Docs: https://www.filebot.net/
            * Manual CLI command (without exclusions):
               * filebot -script fn:amc "/media/downloads/scanned" --output "/media" --action move -non-strict --order Airdate --conflict auto --lang en --def 'music=y' 'unsorted=y' 'clean=y' 'skipExtract=y' 'minLengthMS=0' 'minFileSize=0' 'jellyfin=http://truenas.local:8096:f21977f1699c4a19a2d7be3235154c40' 'seriesFormat={ jellyfin.id }' 'animeFormat=Anime/{ jellyfin.id }' 'movieFormat={ jellyfin.id }' 'musicFormat={ jellyfin.id }' --log all --log-file '/data/filebot/watcher/filebot.log'

### App Config:
1. Gluetun
2. qBittorent
3. ClamAV
4. FileBot
5. JellyFin
