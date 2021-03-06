require 'languages'

module Recruiter
  class GithubCommitAnalyzer
    def self.analyze(repository, commits)
      commits.map do |commit|
        author = commit.author.nil? ? nil : commit.author.login

        data = repository.commit(commit.sha)[:files].map do |file_info|
          language = Languages::Language.by_extension(File.extname(file_info.filename)) || []
          language = language.any? ? language.first.name : nil
          { file: file_info.filename, del: file_info.deletions, add: file_info.additions, language: language }
        end

        {
          author: author,
          data: data
        }
      end.flatten.compact
    end
  end
end
