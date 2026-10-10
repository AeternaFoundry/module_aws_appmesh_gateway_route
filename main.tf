resource "aws_appmesh_gateway_route" "appmesh_gateway_routes" {
  for_each = var.appmesh_gateway_routes

  mesh_name            = each.value.mesh_name
  name                 = each.value.name
  virtual_gateway_name = each.value.virtual_gateway_name
  mesh_owner           = each.value.mesh_owner
  region               = each.value.region
  tags                 = each.value.tags
  tags_all             = each.value.tags_all

  spec {
    dynamic "grpc_route" {
      for_each = each.value.spec.grpc_route != null ? [each.value.spec.grpc_route] : []
      content {
        action {
          target {
            port = grpc_route.value.action.target.port
            virtual_service {
              virtual_service_name = grpc_route.value.action.target.virtual_service.virtual_service_name
            }
          }
        }
        match {
          port         = grpc_route.value.match.port
          service_name = grpc_route.value.match.service_name
        }
      }
    }
    dynamic "http2_route" {
      for_each = each.value.spec.http2_route != null ? [each.value.spec.http2_route] : []
      content {
        action {
          dynamic "rewrite" {
            for_each = http2_route.value.action.rewrite != null ? [http2_route.value.action.rewrite] : []
            content {
              dynamic "hostname" {
                for_each = rewrite.value.hostname != null ? [rewrite.value.hostname] : []
                content {
                  default_target_hostname = hostname.value.default_target_hostname
                }
              }
              dynamic "path" {
                for_each = rewrite.value.path != null ? [rewrite.value.path] : []
                content {
                  exact = path.value.exact
                }
              }
              dynamic "prefix" {
                for_each = rewrite.value.prefix != null ? [rewrite.value.prefix] : []
                content {
                  default_prefix = prefix.value.default_prefix
                  value          = prefix.value.value
                }
              }
            }
          }
          target {
            port = http2_route.value.action.target.port
            virtual_service {
              virtual_service_name = http2_route.value.action.target.virtual_service.virtual_service_name
            }
          }
        }
        match {
          dynamic "header" {
            for_each = http2_route.value.match.header != null ? http2_route.value.match.header : []
            content {
              invert = header.value.invert
              dynamic "match" {
                for_each = header.value.match != null ? [header.value.match] : []
                content {
                  exact  = match.value.exact
                  prefix = match.value.prefix
                  dynamic "range" {
                    for_each = match.value.range != null ? [match.value.range] : []
                    content {
                      end   = range.value.end
                      start = range.value.start
                    }
                  }
                  regex  = match.value.regex
                  suffix = match.value.suffix
                }
              }
              name = header.value.name
            }
          }
          dynamic "hostname" {
            for_each = http2_route.value.match.hostname != null ? [http2_route.value.match.hostname] : []
            content {
              exact  = hostname.value.exact
              suffix = hostname.value.suffix
            }
          }
          dynamic "path" {
            for_each = http2_route.value.match.path != null ? [http2_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }
          port   = http2_route.value.match.port
          prefix = http2_route.value.match.prefix
          dynamic "query_parameter" {
            for_each = http2_route.value.match.query_parameter != null ? http2_route.value.match.query_parameter : []
            content {
              dynamic "match" {
                for_each = query_parameter.value.match != null ? [query_parameter.value.match] : []
                content {
                  exact = match.value.exact
                }
              }
              name = query_parameter.value.name
            }
          }
        }
      }
    }
    dynamic "http_route" {
      for_each = each.value.spec.http_route != null ? [each.value.spec.http_route] : []
      content {
        action {
          dynamic "rewrite" {
            for_each = http_route.value.action.rewrite != null ? [http_route.value.action.rewrite] : []
            content {
              dynamic "hostname" {
                for_each = rewrite.value.hostname != null ? [rewrite.value.hostname] : []
                content {
                  default_target_hostname = hostname.value.default_target_hostname
                }
              }
              dynamic "path" {
                for_each = rewrite.value.path != null ? [rewrite.value.path] : []
                content {
                  exact = path.value.exact
                }
              }
              dynamic "prefix" {
                for_each = rewrite.value.prefix != null ? [rewrite.value.prefix] : []
                content {
                  default_prefix = prefix.value.default_prefix
                  value          = prefix.value.value
                }
              }
            }
          }
          target {
            port = http_route.value.action.target.port
            virtual_service {
              virtual_service_name = http_route.value.action.target.virtual_service.virtual_service_name
            }
          }
        }
        match {
          dynamic "header" {
            for_each = http_route.value.match.header != null ? http_route.value.match.header : []
            content {
              invert = header.value.invert
              dynamic "match" {
                for_each = header.value.match != null ? [header.value.match] : []
                content {
                  exact  = match.value.exact
                  prefix = match.value.prefix
                  dynamic "range" {
                    for_each = match.value.range != null ? [match.value.range] : []
                    content {
                      end   = range.value.end
                      start = range.value.start
                    }
                  }
                  regex  = match.value.regex
                  suffix = match.value.suffix
                }
              }
              name = header.value.name
            }
          }
          dynamic "hostname" {
            for_each = http_route.value.match.hostname != null ? [http_route.value.match.hostname] : []
            content {
              exact  = hostname.value.exact
              suffix = hostname.value.suffix
            }
          }
          dynamic "path" {
            for_each = http_route.value.match.path != null ? [http_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }
          port   = http_route.value.match.port
          prefix = http_route.value.match.prefix
          dynamic "query_parameter" {
            for_each = http_route.value.match.query_parameter != null ? http_route.value.match.query_parameter : []
            content {
              dynamic "match" {
                for_each = query_parameter.value.match != null ? [query_parameter.value.match] : []
                content {
                  exact = match.value.exact
                }
              }
              name = query_parameter.value.name
            }
          }
        }
      }
    }
    priority = each.value.spec.priority
  }
}

