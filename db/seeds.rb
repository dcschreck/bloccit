require 'random_data'

50.times do
    Post.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph
    )
end

posts = Post.all

100.times do
    Comment.create!(
        post: posts.sample,
        body: RandomData.random_paragraph
    )
end

newpost = Post.find_or_create_by(title: "The most newest title", body: "The most newest body")
Comment.find_or_create_by(post: newpost, body:" The most newest comment body")

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
