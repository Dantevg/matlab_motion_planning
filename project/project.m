%% Initialization

% combinations of global and local planners
planners = [
    "a_star"        "pid_plan"; ...
    "voronoi_plan"  "pid_plan"; ...
    "dijkstra"      "pid_plan"; ...
    "",             "dwa_plan"; ...
];

% start and goal pose (y, x, angle)
% TODO: randomize these between runs!
start = [
    3, 2, pi / 2; ...
    4, 2, pi / 2; ...
];

goal = [
    18, 29, pi / 2; ...
    18, 28, pi / 2; ...
];

% load environment
load("gridmap_20x20_scene1.mat");
map_size = size(grid_map);
G = 1;

%% Planning functions

function path = plan_global(planner_name, map, start, goal)
    planner = str2func(planner_name);
    [path, ~, ~, ~] = planner(map, start(:, 1:2), goal(:, 1:2));
end

function pose = plan_local(planner_name, path, map, start, goal)
    planner = str2func(planner_name);
    [pose, ~, ~] = planner(start, goal, "path", path, "map", map);
end

%% Run simulation

poses = cell(length(planners), length(start), length(goal));

% loop over all planners
for planner_i = 1:size(planners, 1)
    planner = planners(planner_i,:);
    % loop over all combinations of starting and ending poses
    for start_i = 1:size(start, 1)
        for goal_i = 1:size(goal, 1)
            start_pose = start(start_i,:);
            goal_pose = goal(goal_i,:);
            fprintf("planner: %12s / %-8s    start: %.2f %.2f %.2f    goal: %.2f %.2f %.2f\n", planner, start_pose, goal_pose)
            if planner(1) ~= ""
                path = plan_global(planner(1), grid_map, start_pose, goal_pose);
            end
            pose = plan_local(planner(2), path, grid_map, start_pose, goal_pose);
            poses{planner_i, start_i, goal_i} = pose;
        end
    end
end

%% Testing
map = generate_map(1);