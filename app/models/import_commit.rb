class ImportCommit 
  attr_reader :username, :repository

  def initialize(username, repository)
    @username = username
    @repository = repository
  end

  def import_commits!
    clear_commits!
    begin
      data = data_from
    rescue StandardError => e
      case e.response.code
        when 404
          raise 'Wrong Name or Repository'
        when 403
          raise 'limit is Exceeded'
      end
    end
    create_data(data)
  end

  private
  def data_from
    n = 1; result = []
    while (request = JSON.parse(RestClient.get "https://api.github.com/repos/#{username}/#{repository}/commits?page=#{n}")).any?
      result += request
      n = n.next
    end
    result
  end

  def create_data(result)
    result.map! do |record|
      user = define_user_by(record)
      create_commit_for!(user, record)
    end
  end

  def define_user_by(record)
    User.find_or_create_by(email: record['commit']['author']['email']) do |user|
      user.name = record['commit']['author']['name']
    end
  end

  def create_commit_for!(user, record)
    user.commits.create(
      sha_hash: record['sha'],
      date: record['commit']['author']['date'],
      description: record['commit']['message']
    )
  end

  def clear_commits!
    User.destroy_all
  end 
end