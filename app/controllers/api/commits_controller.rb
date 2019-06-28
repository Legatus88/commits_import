module Api
  class CommitsController < ApplicationController
    def index
      @commits = Commit.order('date ASC').page(params[:page])
      render json: {status: 'SUCCESS', message: 'Loaded commits', data: @commits}, status: :ok
    end

    def import
      owner        = params['owner']
      repo         = params['repo']
      author_email = params['author_email']

      if owner.blank? || repo.blank? || author_email.blank? 
        render json: {status: 'ERROR', message: 'Commits not saved'}, status: :unprocessable_entity
        return
      end

      Commit.delete_all

      url      = "https://api.github.com/repos/#{owner}/#{repo}/commits?author=#{author_email}"
      response = open(url).read

      saved_commits = []
      JSON.load(response).each do |commit|
        new_commit = Commit.new(owner: owner, repo: repo, author: author_email, date: commit['commit']['author']['date'], info: commit)
        if new_commit.save
          saved_commits.push(new_commit)
        end
      end
      
      unless saved_commits.empty?
        render json: {status: 'SUCCESS', message: 'Commits saved', data: saved_commits}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Commits not found'}, status: :not_found
      end
    end
  end
end