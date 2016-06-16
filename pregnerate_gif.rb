require_relative './lib/gif_timer'
MAX_GIF_AGE = 60 * 60 * 24 * 14
i = 1

while i < MAX_GIF_AGE do
  i = i + 60
  GifTimer::Gif.find_or_create(i)
end