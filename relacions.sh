#!/bin/bash
tail -n +2 superviventsModificat31.csv | while IFS= read -r line; do

    # Utilitzar cut per extreure les columnes necessàries
    video_id=$(echo "$line" | cut -d',' -f1)
    trending_date=$(echo "$line" | cut -d',' -f2)
    title=$(echo "$line" | cut -d',' -f3)
    channel_title=$(echo "$line" | cut -d',' -f4)
    category_id=$(echo "$line" | cut -d',' -f5)
    publish_time=$(echo "$line" | cut -d',' -f6)
    tags=$(echo "$line" | cut -d',' -f7)
    views=$(echo "$line" | cut -d',' -f8)
    likes=$(echo "$line" | cut -d',' -f9)
    dislikes=$(echo "$line" | cut -d',' -f10)
    comment_count=$(echo "$line" | cut -d',' -f11)
    comments_disabled=$(echo "$line" | cut -d',' -f12)
    ratings_disabled=$(echo "$line" | cut -d',' -f13)
    video_error_or_removed=$(echo "$line" | cut -d',' -f14)

    if [ "$views" -lt 1 ]; then
        Rlikes=0.00
        Rdislikes=0.00
    else
        # Calcular Rlikes i Rdislikes
	Rlikes=$(( (likes * 100) / views ))
        Rdislikes=$(( (dislikes * 100) / views ))
    fi

    # Escriure la línia original amb les noves columnes calculades al fitxer de sortida
    echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$comments_disabled,$ratings_disabled,$video_error_or_removed,$Rlikes,$Rdislikes" >> superviventsModificat4.csv

done
