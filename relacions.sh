#!/bin/bash
tail -n +2 superviventsModificat31.csv | while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed; do
    
    # Calcular Rlikes i Rdislikes amb 2 decimals utilitzant bc
    Rlikes=($likes * 100) / $views
    Rdislikes=($dislikes * 100) / $views
    

    # Escriure la línia original amb les noves columnes calculades al fitxer de sortida
    echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$comments_disabled,$ratings_disabled,$video_error_or_removed,$Rlikes,$Rdislikes" >> superviventsModificat4.csv
done

