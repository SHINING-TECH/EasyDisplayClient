import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

/**
 * Api 类
 */
class Test {

  Future<Response> _messages(Request request) async {
    return Response.ok('[]');
  }

  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    // A handler can have more that one route.
    router.get('/messages', _messages);
    router.get('/messages/', _messages);

    // This nested catch-all, will only catch /api/.* when mounted above.
    // Notice that ordering if annotated handlers and mounts is significant.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}