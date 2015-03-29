# Use it like this:
# beforeEach(signIn)
@signIn = ->
  inject (Auth, $httpBackend) ->
    current_user = FactoryGirl.create 'user', id: 1337

    $httpBackend
      .whenGET "/account.json?email=#{current_user.email}"
      .respond current_user

    Auth.setAuthToken current_user.email, '123'
