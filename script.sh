#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
LATEST_MP4=$(ls -1t "$SCRIPT_DIR"/*.mp4 2>/dev/null | head -n 1)
if [ -z "$LATEST_MP4" ]; then
    echo "Erreur : aucun fichier .mp4 trouvé dans le dossier $SCRIPT_DIR"
    exit 1
fi
echo "Fichier vidéo le plus récent : $LATEST_MP4"
OUTPUT_GIF="$SCRIPT_DIR/output.gif"
echo "Conversion en cours..."
ffmpeg -loglevel panic -y -i "$LATEST_MP4" -vf "fps=10,scale=350:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUTPUT_GIF"
if [ $? -eq 0 ]; then
    echo "Conversion terminée avec succès !"
else
    echo "Une erreur est survenue lors de la conversion..."
    exit 1
fi
