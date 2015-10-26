function eventsList($scope, $rootScope, $http ,$window) {
  
    $http.get('http://varunraj.in/gdg.php').success(function (data) {
        $scope.eventsList = data;
    });
}
