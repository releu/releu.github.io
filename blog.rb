require "sinatra"
require "slim"
require "sass"

Post = Struct.new(:name, :title, :body)

def load_posts
  Dir["./posts/*.slim"].map do |post_path|
    name = post_path[%r{\./posts/(\d+)-(.*)\.slim}, 2]
    title = File.read(post_path).lines.first.sub(/^- #/, "").strip
    body = Slim::Template.new(post_path).render
    Post.new(name, title, body)
  end
end

get "/" do
  @posts = load_posts
  slim :posts
end

get "/posts/:name" do
  @posts = load_posts
  idx = @posts.find_index { |p| p.name == params[:name] }

  @post = @posts[idx]
  if idx > 0
    @prev_post = @posts[idx - 1]
  end
  @next_post = @posts[idx + 1]

  slim :post
end

get "/application.css" do
  scss :application
end
