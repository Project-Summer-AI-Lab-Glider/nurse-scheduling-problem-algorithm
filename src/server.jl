using Genie, Genie.Router, Genie.Renderer.Json, Genie.Requests
using HTTP
include("repair_schedule.jl")

Genie.config.run_as_server = true
Genie.config.server_host = "0.0.0.0"
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

route("/fix_schedule", method = POST) do

    schedule_data = jsonpayload()

    repaired_shifts = repair_schedule(schedule_data)

    schedule = Schedule(schedule_data)

    update_shifts!(schedule, repaired_shifts)

    schedule.data |> json
end

route("/schedule_errors", method = POST) do
    schedule = jsonpayload()

    errors = get_errors(schedule)

    errors |> json
end

Genie.startup(async = false)