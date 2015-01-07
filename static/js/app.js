var app;

app = angular.module("app", ['ngRoute']).config(function($routeProvider) {
  return $routeProvider.when("/", {
    templateUrl: "templates/main.html"
  }).when("/404", {
    templateUrl: "templates/404.html"
  }).otherwise({
    redirectTo: "/404"
  });
});

app.controller('main', function($scope) {
  return $scope.message = "Welcome!";
});
