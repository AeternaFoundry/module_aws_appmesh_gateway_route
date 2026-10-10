variable "appmesh_gateway_routes" {
  description = <<EOT
Map of appmesh_gateway_routes, attributes below
Required:
    - mesh_name
    - name
    - virtual_gateway_name
    - spec (block):
        - grpc_route (optional, block):
            - action (required, block):
                - target (required, block):
                    - port (optional)
                    - virtual_service (required, block):
                        - virtual_service_name (required)
            - match (required, block):
                - port (optional)
                - service_name (required)
        - http2_route (optional, block):
            - action (required, block):
                - rewrite (optional, block):
                    - hostname (optional, block):
                        - default_target_hostname (required)
                    - path (optional, block):
                        - exact (required)
                    - prefix (optional, block):
                        - default_prefix (optional)
                        - value (optional)
                - target (required, block):
                    - port (optional)
                    - virtual_service (required, block):
                        - virtual_service_name (required)
            - match (required, block):
                - header (optional, block):
                    - invert (optional)
                    - match (optional, block):
                        - exact (optional)
                        - prefix (optional)
                        - range (optional, block):
                            - end (required)
                            - start (required)
                        - regex (optional)
                        - suffix (optional)
                    - name (required)
                - hostname (optional, block):
                    - exact (optional)
                    - suffix (optional)
                - path (optional, block):
                    - exact (optional)
                    - regex (optional)
                - port (optional)
                - prefix (optional)
                - query_parameter (optional, block):
                    - match (optional, block):
                        - exact (optional)
                    - name (required)
        - http_route (optional, block):
            - action (required, block):
                - rewrite (optional, block):
                    - hostname (optional, block):
                        - default_target_hostname (required)
                    - path (optional, block):
                        - exact (required)
                    - prefix (optional, block):
                        - default_prefix (optional)
                        - value (optional)
                - target (required, block):
                    - port (optional)
                    - virtual_service (required, block):
                        - virtual_service_name (required)
            - match (required, block):
                - header (optional, block):
                    - invert (optional)
                    - match (optional, block):
                        - exact (optional)
                        - prefix (optional)
                        - range (optional, block):
                            - end (required)
                            - start (required)
                        - regex (optional)
                        - suffix (optional)
                    - name (required)
                - hostname (optional, block):
                    - exact (optional)
                    - suffix (optional)
                - path (optional, block):
                    - exact (optional)
                    - regex (optional)
                - port (optional)
                - prefix (optional)
                - query_parameter (optional, block):
                    - match (optional, block):
                        - exact (optional)
                    - name (required)
        - priority (optional)
Optional:
    - mesh_owner
    - region
    - tags
    - tags_all
EOT

  type = map(object({
    mesh_name            = string
    name                 = string
    virtual_gateway_name = string
    mesh_owner           = optional(string)
    region               = optional(string)
    tags                 = optional(map(string))
    tags_all             = optional(map(string))
    spec = object({
      grpc_route = optional(object({
        action = object({
          target = object({
            port = optional(number)
            virtual_service = object({
              virtual_service_name = string
            })
          })
        })
        match = object({
          port         = optional(number)
          service_name = string
        })
      }))
      http2_route = optional(object({
        action = object({
          rewrite = optional(object({
            hostname = optional(object({
              default_target_hostname = string
            }))
            path = optional(object({
              exact = string
            }))
            prefix = optional(object({
              default_prefix = optional(string)
              value          = optional(string)
            }))
          }))
          target = object({
            port = optional(number)
            virtual_service = object({
              virtual_service_name = string
            })
          })
        })
        match = object({
          header = optional(list(object({
            invert = optional(bool)
            match = optional(object({
              exact  = optional(string)
              prefix = optional(string)
              range = optional(object({
                end   = number
                start = number
              }))
              regex  = optional(string)
              suffix = optional(string)
            }))
            name = string
          })))
          hostname = optional(object({
            exact  = optional(string)
            suffix = optional(string)
          }))
          path = optional(object({
            exact = optional(string)
            regex = optional(string)
          }))
          port   = optional(number)
          prefix = optional(string)
          query_parameter = optional(list(object({
            match = optional(object({
              exact = optional(string)
            }))
            name = string
          })))
        })
      }))
      http_route = optional(object({
        action = object({
          rewrite = optional(object({
            hostname = optional(object({
              default_target_hostname = string
            }))
            path = optional(object({
              exact = string
            }))
            prefix = optional(object({
              default_prefix = optional(string)
              value          = optional(string)
            }))
          }))
          target = object({
            port = optional(number)
            virtual_service = object({
              virtual_service_name = string
            })
          })
        })
        match = object({
          header = optional(list(object({
            invert = optional(bool)
            match = optional(object({
              exact  = optional(string)
              prefix = optional(string)
              range = optional(object({
                end   = number
                start = number
              }))
              regex  = optional(string)
              suffix = optional(string)
            }))
            name = string
          })))
          hostname = optional(object({
            exact  = optional(string)
            suffix = optional(string)
          }))
          path = optional(object({
            exact = optional(string)
            regex = optional(string)
          }))
          port   = optional(number)
          prefix = optional(string)
          query_parameter = optional(list(object({
            match = optional(object({
              exact = optional(string)
            }))
            name = string
          })))
        })
      }))
      priority = optional(number)
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        v.spec.http2_route == null || (v.spec.http2_route.match.header == null || (length(v.spec.http2_route.match.header) <= 10))
      )
    ])
    error_message = "Each header list must contain at most 10 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        v.spec.http2_route == null || (v.spec.http2_route.match.query_parameter == null || (length(v.spec.http2_route.match.query_parameter) <= 10))
      )
    ])
    error_message = "Each query_parameter list must contain at most 10 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        v.spec.http_route == null || (v.spec.http_route.match.header == null || (length(v.spec.http_route.match.header) <= 10))
      )
    ])
    error_message = "Each header list must contain at most 10 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        v.spec.http_route == null || (v.spec.http_route.match.query_parameter == null || (length(v.spec.http_route.match.query_parameter) <= 10))
      )
    ])
    error_message = "Each query_parameter list must contain at most 10 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        length(v.mesh_name) >= 1 && length(v.mesh_name) <= 255
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.appmesh_gateway_routes : (
        length(v.virtual_gateway_name) >= 1 && length(v.virtual_gateway_name) <= 255
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  # Note: 6 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

