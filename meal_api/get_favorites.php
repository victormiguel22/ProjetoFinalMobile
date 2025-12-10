<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dataFile = 'data/favorites.json';

// Criar pasta data se não existir
if (!file_exists('data')) {
    mkdir('data', 0777, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);
    
    if (isset($data['favorites'])) {
        $favorites = $data['favorites'];
        
        // Salvar favoritos no arquivo JSON
        $result = file_put_contents($dataFile, json_encode($favorites, JSON_PRETTY_PRINT));
        
        if ($result !== false) {
            echo json_encode([
                'success' => true,
                'message' => 'Favoritos sincronizados com sucesso',
                'count' => count($favorites)
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erro ao salvar favoritos'
            ]);
        }
    } else {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => 'Dados inválidos'
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'Método não permitido'
    ]);
}
?>