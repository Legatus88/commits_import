require "rails_helper"

RSpec.describe "Import commits", :type => :request do
  it "responds with message 'Commits not saved'" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'legatus88', repo: 'kino' }
    expect(JSON.parse(response.body)['message']).to eq "Commits not saved"
  end

  it "responds with message 'Commits not found'" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'legatus88', repo: 'kino', author_email: '11111111111' }
    expect(JSON.parse(response.body)['message']).to eq "Commits not found"
  end

  it "responds with message 'Commits saved'" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'legatus88', repo: 'kino', author_email: 'y1wkn8@gmail.com' }
    expect(JSON.parse(response.body)['message']).to eq "Commits saved"
  end

  it "creates 1 record in db" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'thoughtbot', repo: 'guides', author_email: 'vcavallo@gmail.com' }
    expect(Commit.count).to eq 1
  end

  it "deletes old records and creates new" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'legatus88', repo: 'kino', author_email: 'y1wkn8@gmail.com' }
    expect(Commit.count).to eq 30

    post 'http://localhost:3000/api/commits/import', :params => { owner: 'thoughtbot', repo: 'guides', author_email: 'vcavallo@gmail.com' }
    expect(Commit.count).to eq 1
  end

  it "doesn't change anything if any params are missing" do 
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'thoughtbot', repo: 'guides', author_email: 'vcavallo@gmail.com' }
    expect(Commit.count).to eq 1

    post 'http://localhost:3000/api/commits/import', :params => { owner: 'legatus88', repo: 'kino' }
    expect(Commit.count).to eq 1
  end

  it "creates record with correct fields" do
    post 'http://localhost:3000/api/commits/import', :params => { owner: 'thoughtbot', repo: 'guides', author_email: 'vcavallo@gmail.com' }
    expect(Commit.first[:owner]).to eq 'thoughtbot'
    expect(Commit.first[:repo]).to eq 'guides'
    expect(Commit.first[:author]).to eq 'vcavallo@gmail.com'
  end
end