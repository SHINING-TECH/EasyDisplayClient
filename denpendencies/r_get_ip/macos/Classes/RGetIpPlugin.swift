import Cocoa
import FlutterMacOS
import Foundation

public class RGetIpPlugin: NSObject, FlutterPlugin {
  let dispatchQueue = DispatchQueue(label: "Ipify")
  let dispatchGroup  = DispatchGroup()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "r_get_ip", binaryMessenger: registrar.messenger)
    let instance = RGetIpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "getExternalIP":
          getExternalIP(result: result)
      case "getInternalIP":
          getInternalIP(result: result)
      case "getNetworkType":
          result(getNetworkType())
      default:
          result(FlutterMethodNotImplemented)
      }
    }

    public func getInternalIP(result: @escaping FlutterResult) {
      var address: String!
      var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil

      if getifaddrs(&ifaddr) == 0 {
          var ptr = ifaddr
          while ptr != nil {
              defer { ptr = ptr?.pointee.ifa_next }

              let interface = ptr?.pointee
              let addrFamily = interface?.ifa_addr.pointee.sa_family
              if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                  let name: String = String(cString: (interface!.ifa_name))

                  if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                      var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                      getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)

                      let temp = String(cString: hostname)

                      if(temp.contains("fe80::") || temp.contains(":")){
                          print(temp)
                      } else {
                          address = temp
                          print(temp + " name:" + name)
                      }
                  }
              }
          }
          freeifaddrs(ifaddr)
      }
      result(address)
    }


      public func getExternalIP(result: @escaping FlutterResult) {
          var address: String?
          dispatchQueue.async {
              self.dispatchGroup.enter()
              Ipify.getPublicIPAddress { result in
                  switch result {
                  case .success(let ip):
                      print(ip)
                      address = ip
                      self.dispatchGroup.leave()

                  case .failure(let error):
                      print(error.localizedDescription)
                      address = ""
                      self.dispatchGroup.leave()
                  }
              }

              self.dispatchGroup.wait(timeout: .distantFuture)
              result(address ?? "")
          }
      }

      public func getNetworkType() -> String {
          var type: String?
          var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
          if getifaddrs(&ifaddr) == 0 {
              var ptr = ifaddr
              while ptr != nil {
                  defer { ptr = ptr?.pointee.ifa_next }

                  let interface = ptr?.pointee
                  let addrFamily = interface?.ifa_addr.pointee.sa_family
                  if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                      let wifi = ["en0"]
                      let wired = ["en2", "en3", "en4"]
                      let cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                      let name: String = String(cString: (interface!.ifa_name))

                      if (wifi.contains(name)) { type = "wifi" }

                      if (wired.contains(name)) { type = "wired" }

                      if (cellular.contains(name)) { type = "cellular" }
                  }
              }
              freeifaddrs(ifaddr)
          }
          return type ?? ""
      }
  }

  public struct Ipify {

      public typealias JSONDictionary = [String: Any]
      public typealias CompletionHandler = (Result) -> Void

      public enum Result {
          case success(String)
          case failure(CustomError)
      }

      public enum CustomError: LocalizedError {
          case noData
          case invalidJson
          case otherError(Error)

          public var errorDescription: String? {
              switch self {
              case .noData:
                  return "There was no data on the server response."
              case .invalidJson:
                  return "Error parsing the JSON file from the server."
              case .otherError(let err):
                  return err.localizedDescription
              }
          }
      }

      internal static var serviceURL = "https://api.ipify.org?format=json"    // var only for unit testabilty

      public static func getPublicIPAddress(completion: @escaping CompletionHandler) {
          let url = URL(string: Ipify.serviceURL)!

          URLSession.shared.dataTask(with: url) { data, response, error in
              handleIpifyResponse(with: data, error: error, completion: completion)
              }.resume()
      }

      internal static func handleIpifyResponse(with data: Data?, error: Error?, completion: @escaping CompletionHandler) {
          guard error == nil else {
              completion(Result.failure(CustomError.otherError(error!)))
              return
          }
          guard let data = data else {
              completion(Result.failure(CustomError.noData))
              return
          }

          do {
              if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary, let ip = json["ip"] as? String {
                  completion(Result.success(ip))
              }
          } catch {
              completion(Result.failure(CustomError.invalidJson))
          }
      }
  }