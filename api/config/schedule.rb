every 1.week do
  rake 'send_review_email:all'
end

every :month do
  rake 'send_review_email:all'
end