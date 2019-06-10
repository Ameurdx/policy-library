#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPIAMAuditLogConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "cloudresourcemanager.googleapis.com/Project"
	audit_configs := lib.get_default(asset.iam_policy, "audit_configs", {})
	configs := [c | c = audit_configs[_]; c.service == params.service; c.audit_log_configs[_].log_type == params.log_type]
	count(configs) == 0
	message := sprintf("IAM policy for %v is missing audit log type %v for service %v", [asset.name, params.log_type, params.service])
	metadata := {"resource": asset.name}
}
