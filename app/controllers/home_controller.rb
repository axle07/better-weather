class HomeController < ApplicationController
    def index
        @loc = request.location
    end
end
