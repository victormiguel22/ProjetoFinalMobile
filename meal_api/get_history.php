<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

$dataFile = 'data/view_history.json';

if (file_exists($dataFile)) {
    $history = json_decode(file_get_contents($dataFile), true);
    
    echo json_encode([
        'success' => true,
        'history' => $history ?? [],
        'count' => count($history ?? [])
    ]);
} else {
    echo json_encode([
        'success' => true,
        'history' => [],
        'count' => 0
    ]);
}
?>