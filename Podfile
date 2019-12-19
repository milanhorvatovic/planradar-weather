platform :ios, '10.0'
use_frameworks!

workspace 'PlanRadar Weather'

def network_pods

    #pod 'AFNetworking', '~> 3.2'
    pod 'AFNetworking', '3.2.1'
    #pod 'AFNetworking'

end

def data_pods
    
    #pod 'Mantle', '~> 2.1'
    pod 'Mantle', '2.1.0'
    #pod 'Mantle'

end

def ui_pods

    #pod 'SVProgressHUD', '~> 2.2'
    pod 'SVProgressHUD', '2.2.5'
    #pod 'SVProgressHUD'

end

def resources_pods

end

def supplementary_pods
  
    #pod 'CocoaLumberjack/Swift', '~> 3.6'
    #pod 'CocoaLumberjack/Swift', '3.6.0'
    #pod 'CocoaLumberjack/Swift'
  
end

def all_pods

    network_pods
    data_pods
    ui_pods
    resources_pods
    supplementary_pods

end

def tests_pods

end

target 'PlanRadar Weather' do
    project 'PlanRadar Weather.xcodeproj'

    all_pods

end

target 'PlanRadar WeatherTests' do
    project 'PlanRadar Weather.xcodeproj'

    all_pods
    tests_pods

end
