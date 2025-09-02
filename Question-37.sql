SELECT
  pt.track_id,
  COUNT(DISTINCT pt.playlist_id) AS playlistcount
FROM playlist_tracks pt
WHERE pt.playlist_id IN (
  SELECT playlist_id
  FROM playlist_plays
  GROUP BY playlist_id
  HAVING COUNT(DISTINCT user_id) >= 2
)
GROUP BY pt.track_id
ORDER BY playlistcount DESC, pt.track_id DESC
LIMIT 2;