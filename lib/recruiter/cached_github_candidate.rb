require 'recruiter/github_candidate'
require 'recruiter/cached_github_repository'
require 'recruiter/cached_github_organization'
require 'recruiter/redis_cache'
require 'recruiter/cache_mechanism'

module Recruiter
  class CachedGithubCandidate
    include CacheMechanism

    def initialize(candidate, caching_method)
      @composite = candidate
      @caching_method = caching_method
    end

    def cache_namespace
      login
    end

    def client
      @composite.client
    end

    def login
      @composite.login
    end

    def languages_2(repos)
      skills.languages_2(repos)
    end

    def repositories_contributed
      @composite.repositories_contributed
    end

    def skills
      ::Recruiter::GithubCandidate::Skills.new(self)
    end

    def activity
      ::Recruiter::GithubCandidate::Activity.new(self)
    end

    def organization_list
      organization_list_data.map do |org|
        Recruiter::CachedGithubOrganization.new(Recruiter::GithubOrganization.new(org, client), @caching_method)
      end
    end

    def repositories(type='public')
      repositories_data(type).map do |repo|
        Recruiter::CachedGithubRepository.new(Recruiter::GithubRepository.new(repo, client), @caching_method)
      end
    end

    def following
      following_users_data.map do |following|
        Recruiter::CachedGithubCandidate.new(Recruiter::GithubCandidate.new(following, client), @caching_method)
      end
    end
  end
end
