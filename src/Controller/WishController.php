<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class WishController extends AbstractController
{
    #[Route('/wish', name: 'app_wish', methods: ['GET'])]
    public function index(): Response
    {
        return $this->render('wish/index.html.twig');
    }

    // 👈 NOUVELLE ROUTE POUR AFFICHER LA CARTE UNIQUE
    #[Route('/wish/view', name: 'app_wish_view', methods: ['GET'])]
    public function view(): Response
    {
        return $this->render('wish/view.html.twig');
    }
}
